import bicephalus


class BasePage:
    def __init__(self, request):
        self.request = request

    def response(self):
        if self.request.proto == bicephalus.Proto.GEMINI:
            status, content_type, content = self.get_gemini_content()
        elif self.request.proto == bicephalus.Proto.HTTP:
            status, content_type, content = self.get_http_content()
        else:
            assert False, f"unknown protocol {self.request.proto}"

        return bicephalus.Response(
            content=content.encode("utf8"),
            content_type=content_type,
            status=bicephalus.Status.OK,
        )


class NotFound(BasePage):
    def get_gemini_content(self):
        # TODO: does not work!
        return (
            bicephalus.Status.NOT_FOUND,
            "text/gemini",
            f"{self.request.path} not found",
        )

    def get_http_content(self):
        return (
            bicephalus.Status.NOT_FOUND,
            "text/html",
            f"{self.request.path} not found",
        )
