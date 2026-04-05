#!/usr/bin/env ruby
# frozen_string_literal: true

require "mcp"
require "json"

# Define the "hello" tool as a class
class HelloTool < MCP::Tool
  description "Say hello to someone"
  input_schema(
    properties: {
      name: { type: "string", description: "The person's name" },
    },
    required: ["name"],
  )

  class << self
    def call(name:)
      MCP::Tool::Response.new([{
        type: "text",
        text: "Hello, #{name}!",
      }])
    end
  end
end

# Define the "add" tool as a class
class AddTool < MCP::Tool
  description "Add two numbers together"
  input_schema(
    properties: {
      a: { type: "number", description: "First number" },
      b: { type: "number", description: "Second number" },
    },
    required: ["a", "b"],
  )

  class << self
    def call(a:, b:)
      MCP::Tool::Response.new([{
        type: "text",
        text: { sum: a + b }.to_json,
      }])
    end
  end
end

# Create the server with both tools
server = MCP::Server.new(
  name: "example-server",
  version: "1.0.0",
  tools: [HelloTool, AddTool],
)

# Create and start the stdio transport
transport = MCP::Server::Transports::StdioTransport.new(server)
transport.open
