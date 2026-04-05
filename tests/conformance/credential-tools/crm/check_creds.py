tool = {
    "description": "Check if credentials were injected",
    "input": {},
}


async def execute(args, ctx):
    return {
        "has_credentials": ctx.credentials is not None,
        "value": ctx.credentials,
    }
