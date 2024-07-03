package com.example.config_client.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MessageController {

    @Value("${message:Config Server не доступен}")
    private String message;

    @GetMapping("/message")
    public String getMessage() {
        return this.message;
    }
}