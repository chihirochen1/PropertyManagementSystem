package com.property.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.User;
import com.property.mapper.UserMapper;
import com.property.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    public User login(String username, String password) {
        User user = this.lambdaQuery().eq(User::getUsername, username).one();
        if (user != null && DigestUtils.md5DigestAsHex(password.getBytes()).equals(user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        return this.save(user);
    }

    @Override
    public boolean updatePassword(Long id, String oldPassword, String newPassword) {
        User user = this.getById(id);
        if (user != null && DigestUtils.md5DigestAsHex(oldPassword.getBytes()).equals(user.getPassword())) {
            user.setPassword(DigestUtils.md5DigestAsHex(newPassword.getBytes()));
            return this.updateById(user);
        }
        return false;
    }
}