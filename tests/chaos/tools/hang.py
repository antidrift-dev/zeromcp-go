import asyncio

tool = {"description": "Tool that hangs forever", "input": {}}

async def execute(args, ctx):
    await asyncio.Future()  # never resolves
