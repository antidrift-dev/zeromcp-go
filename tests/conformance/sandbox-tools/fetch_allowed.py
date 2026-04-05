tool = {
    "description": "Fetch an allowed domain",
    "input": {},
    "permissions": {
        "network": ["localhost"],
    },
}


async def execute(args, ctx):
    try:
        res = await ctx.fetch("http://localhost:18923/test")
        return {"status": "ok", "domain": "localhost"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
