tool = {
    "description": "Tool with network disabled",
    "input": {},
    "permissions": {
        "network": False,
    },
}


async def execute(args, ctx):
    try:
        await ctx.fetch("http://localhost:18923/test")
        return {"blocked": False}
    except Exception:
        return {"blocked": True}
