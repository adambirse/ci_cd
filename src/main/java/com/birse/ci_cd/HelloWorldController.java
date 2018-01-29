package com.birse.ci_cd;

import jdk.nashorn.internal.objects.annotations.Getter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created on 29/01/2018.
 */
@RestController
public class HelloWorldController {

    @RequestMapping("/greeting")
    public String hello() {
        return "Hello World";
    }

}
