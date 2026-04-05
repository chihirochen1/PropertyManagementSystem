package com.property.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.property.entity.User;
import com.property.mapper.UserMapper;
import com.property.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@RestController
public class LoginController {

    @Autowired
    private UserMapper userMapper;

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");

        Map<String, Object> result = new HashMap<>();

        try {
            QueryWrapper<User> wrapper = new QueryWrapper<>();
            wrapper.eq("username", username);

            User user = userMapper.selectOne(wrapper);

            if (user == null) {
                result.put("code", 500);
                result.put("msg", "用户不存在");
                return result;
            }

            if (user.getStatus() != null && user.getStatus() != 1) {
                result.put("code", 500);
                result.put("msg", "账号已禁用");
                return result;
            }

            // 把前端输入的明文密码转成 MD5，再和数据库比较
            String md5Password = DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8));

            if (!md5Password.equalsIgnoreCase(user.getPassword())) {
                result.put("code", 500);
                result.put("msg", "用户名或密码错误");
                return result;
            }

            String token = JwtUtils.generateToken(user.getId(), user.getRoleId());

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("id", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("realName", user.getRealName());
            userInfo.put("roleId", user.getRoleId());

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", userInfo);

            result.put("code", 200);
            result.put("msg", "登录成功");
            result.put("data", data);
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "后端异常：" + e.getMessage());
            return result;
        }
    }
}