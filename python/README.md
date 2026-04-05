# ZeroMCP &mdash; Python

Drop a `.py` file in a folder, get a sandboxed MCP server. Stdio out of the box, zero dependencies.

## Getting started

```python
# tools/hello.py — this is a complete MCP server
tool = {
    "description": "Say hello to someone",
    "input": {"name": "string"},
}

async def execute(args, ctx):
    return f"Hello, {args['name']}!"
```

```sh
python3 -m zeromcp serve ./tools
```

That's it. Stdio transport works immediately. Drop another `.py` file to add another tool. Delete a file to remove one. No server object, no decorators, no main block.

## vs. the official SDK

The official Python SDK (FastMCP) requires a server object, decorators, and a `__main__` block. Adding a tool means editing server code and restarting. ZeroMCP is file-based &mdash; each tool is its own file, discovered automatically.

The official SDK also pulls in pydantic, httpx, uvicorn, starlette, and more. **ZeroMCP uses only the standard library.**

The official SDK has **no sandbox**. ZeroMCP enforces per-tool network allowlists, credential isolation, and filesystem controls at runtime.

## Requirements

- Python 3.10+
- No external dependencies (stdlib only)

## Install

```sh
pip install -e .
```

## Defining tools

```python
# tools/add.py
tool = {
    "description": "Add two numbers together",
    "input": {"a": "number", "b": "number"},
}

async def execute(args, ctx):
    return {"sum": args["a"] + args["b"]}
```

### Input types

Shorthand strings: `"string"`, `"number"`, `"boolean"`, `"object"`, `"array"`.

### Returning values

Return a string or a dict. ZeroMCP wraps it in the MCP content envelope for you.

## Sandbox

The Python implementation has full runtime sandboxing.

### Network allowlists

```python
tool = {
    "description": "Fetch from our API",
    "input": {"endpoint": "string"},
    "permissions": {
        "network": ["api.example.com", "*.internal.dev"],
    },
}

async def execute(args, ctx):
    res = await ctx.fetch(f"https://api.example.com/{args['endpoint']}")
    return res["body"]
```

`ctx.fetch` validates the hostname against the allowlist. Unlisted domains are blocked and logged.

### Credential injection

Tools receive secrets via `ctx.credentials`, configured per namespace. Tools never call `os.environ` directly.

### Filesystem and exec control

Tools must declare `fs: 'read'` or `fs: 'write'` for filesystem access. Static auditing and proxy objects enforce the restrictions.

## Directory structure

Tools are discovered recursively. Subdirectory names become namespace prefixes:

```
tools/
  hello.py          -> tool "hello"
  math/
    add.py          -> tool "math_add"
```

## Configuration

Optional `zeromcp.config.json` in the working directory. See the [root README](../README.md#configuration) for the full schema.

## Testing

```sh
python3 -m pytest
```
