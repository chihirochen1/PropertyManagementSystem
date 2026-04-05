package com.property.controller;

import com.property.entity.User;
import com.property.service.UserService;
import com.property.utils.JwtUtils;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result login(@RequestBody User user) {
        User loginUser = userService.login(user.getUsername(), user.getPassword());
        if (loginUser != null) {
            String token = JwtUtils.generateToken(loginUser.getId(), loginUser.getRoleId());
            return Result.success().data("token", token).data("user", loginUser);
        }
        return Result.error("用户名或密码错误");
    }

    @PostMapping("/register")
    public Result register(@RequestBody User user) {
        boolean result = userService.register(user);
        if (result) {
            return Result.success("注册成功");
        }
        return Result.error("注册失败");
    }

    @PostMapping("/updatePassword")
    public Result updatePassword(@RequestParam Long id, @RequestParam String oldPassword, @RequestParam String newPassword) {
        boolean result = userService.updatePassword(id, oldPassword, newPassword);
        if (result) {
            return Result.success("密码修改成功");
        }
        return Result.error("密码修改失败");
    }
}