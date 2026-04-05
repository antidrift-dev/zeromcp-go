/**
 * ZeroMCP HTTP handler — framework-agnostic JSON-RPC handler.
 *
 * Usage:
 *   const handler = await createHandler('./tools');
 *   const response = await handler(jsonRpcRequest);
 *
 * Works with any HTTP framework:
 *   app.post('/mcp', async (req, res) => res.json(await handler(req.body)));
 */

import { ToolScanner, type ToolDefinition } from './scanner.js';
import { toJsonSchema, validate } from './schema.js';
import { loadConfig, type Config } from './config.js';

interface JsonRpcRequest {
  jsonrpc: string;
  id?: number | string;
  method: string;
  params?: Record<string, unknown>;
}

interface JsonRpcResponse {
  jsonrpc: string;
  id?: number | string;
  result?: unknown;
  error?: { code: number; message: string };
}

export type McpHandler = (request: JsonRpcRequest) => Promise<JsonRpcResponse | null>;

/**
 * Create a ZeroMCP handler from a tools directory or config.
 *
 * @param toolsOrConfig - Path to tools directory, config object, or config file path
 * @returns A function that handles JSON-RPC requests
 */
export async function createHandler(toolsOrConfig?: string | Config): Promise<McpHandler> {
  let config: Config;

  if (typeof toolsOrConfig === 'string') {
    // Could be a tools directory or a config file
    if (toolsOrConfig.endsWith('.json')) {
      config = await loadConfig(toolsOrConfig);
    } else {
      config = { tools: [toolsOrConfig] };
    }
  } else {
    config = toolsOrConfig || {};
  }

  const scanner = new ToolScanner(config);
  await scanner.scan();
  const tools = scanner.tools;

  const executeTimeout = config.execute_timeout ?? 30000;

  console.error(`[zeromcp] ${tools.size} tool(s) loaded`);

  return async (request: JsonRpcRequest): Promise<JsonRpcResponse | null> => {
    if (!request || typeof request !== 'object') return null;

    const { id, method, params } = request;

    if (id === undefined && method === 'notifications/initialized') {
      return null;
    }

    switch (method) {
      case 'initialize':
        return {
          jsonrpc: '2.0',
          id,
          result: {
            protocolVersion: '2024-11-05',
            capabilities: { tools: { listChanged: true } },
            serverInfo: { name: 'zeromcp', version: '0.1.0' },
          },
        };

      case 'tools/list':
        return {
          jsonrpc: '2.0',
          id,
          result: { tools: buildToolList(tools) },
        };

      case 'tools/call':
        return {
          jsonrpc: '2.0',
          id,
          result: await callTool(tools, params as { name: string; arguments?: Record<string, unknown> }, executeTimeout),
        };

      case 'ping':
        return { jsonrpc: '2.0', id, result: {} };

      default:
        if (id === undefined) return null;
        return {
          jsonrpc: '2.0',
          id,
          error: { code: -32601, message: `Method not found: ${method}` },
        };
    }
  };
}

function buildToolList(tools: Map<string, ToolDefinition>) {
  const list = [];
  for (const [name, tool] of tools) {
    list.push({
      name,
      description: tool.description,
      inputSchema: toJsonSchema(tool.input),
    });
  }
  return list;
}

async function callTool(
  tools: Map<string, ToolDefinition>,
  params: { name: string; arguments?: Record<string, unknown> },
  defaultTimeout: number = 30000
) {
  const name = params?.name ?? '';
  const args = params?.arguments ?? {};

  const tool = tools.get(name);
  if (!tool) {
    return {
      content: [{ type: 'text', text: `Unknown tool: ${name}` }],
      isError: true,
    };
  }

  const schema = toJsonSchema(tool.input);
  const errors = validate(args, schema);
  if (errors.length > 0) {
    return {
      content: [{ type: 'text', text: `Validation errors:\n${errors.join('\n')}` }],
      isError: true,
    };
  }

  const timeout = tool.execute_timeout ?? defaultTimeout;

  try {
    const result = await withTimeout(tool.execute(args), timeout, name);
    const text = typeof result === 'string' ? result : JSON.stringify(result);
    return { content: [{ type: 'text', text }] };
  } catch (err) {
    return {
      content: [{ type: 'text', text: `Error: ${(err as Error).message}` }],
      isError: true,
    };
  }
}

function withTimeout<T>(promise: Promise<T>, ms: number, toolName: string): Promise<T> {
  if (ms <= 0) return promise;
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      reject(new Error(`Tool "${toolName}" timed out after ${ms}ms`));
    }, ms);
    promise.then(
      (val) => { clearTimeout(timer); resolve(val); },
      (err) => { clearTimeout(timer); reject(err); }
    );
  });
}
