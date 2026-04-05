tool = {
    "description": "Check credentials in unconfigured namespace",
    "input": {},
}


async def execute(args, ctx):
    return {
        "has_credentials": ctx.credentials is not None,
        "value": ctx.credentials,
    }
