tool = {"description": "Tool that throws", "input": {}}

async def execute(args, ctx):
    raise RuntimeError("Intentional chaos: unhandled exception")
