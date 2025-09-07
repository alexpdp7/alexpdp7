from p7s import multiline_string as _


class ImapServer:
    def __init__(self, name, server, username, password):
        self.name = name
        self.server = server
        self.username = username
        self.password = password

    def lua(self):
        return _(f"""
        {self.name} = IMAP {{
            server = '{self.server}',
            username = '{self.username}',
            password = '{self.password}',
            ssl = 'auto',
        }}
        """)


class Sync:
    def __init__(self, from_server: ImapServer, to_server: ImapServer):
        self.from_server = from_server
        self.to_server = to_server

    def lua(self):
        s = self.from_server.lua()
        s += "\n"
        s += self.to_server.lua()
        s += "\n"
        s += _(f"""
        while true do
            results = {self.from_server.name}.INBOX:is_unseen()
            results:move_messages({self.to_server.name}.INBOX)
            {self.from_server.name}.INBOX:enter_idle()
        end
        """)
        return s
