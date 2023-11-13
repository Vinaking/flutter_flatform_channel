package com.example.flutter_platform_channel

import MessageApi
import MyMessage

class MyMessageApi: MessageApi {
    private val messages = listOf<MyMessage>(
        MyMessage(
            title = "Hello 1",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 2",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 3",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 4",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 5",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 6",
            body = "",
            email = "hot@gmail.com"
        ),
        MyMessage(
            title = "Hello 7",
            body = "",
            email = "hot11@gmail.com"
        ),
    )
    override fun getMessages(fromEmail: String): List<MyMessage> {
        return messages.filter { it.email == fromEmail }
    }
}