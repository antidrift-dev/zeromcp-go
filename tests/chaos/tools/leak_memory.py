_leaks = []

tool = {"description": "Tool that leaks memory", "input": {}}

async def execute(args, ctx):
    _leaks.append(bytearray(1024 * 1024))  # 1MB per call
    return {"leaked_buffers": len(_leaks), "total_mb": len(_leaks)}
