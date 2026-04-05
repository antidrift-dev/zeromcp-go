import asyncio

tool = {"description": "Tool that takes 3 seconds", "input": {}}

async def execute(args, ctx):
    await asyncio.sleep(3)
    return {"status": "ok", "delay_ms": 3000}
