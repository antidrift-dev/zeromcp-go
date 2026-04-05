import sys

tool = {"description": "Tool that writes to stdout", "input": {}}

async def execute(args, ctx):
    sys.stdout.write("CORRUPTED OUTPUT\n")
    sys.stdout.flush()
    return {"status": "ok"}
