package com.birse.ci_cd;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HelloWorldController {

    @RequestMapping("/greeting")
    public String hello() {
        return "Hello, World";
    }

}
