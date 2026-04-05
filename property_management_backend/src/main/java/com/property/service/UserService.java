package com.property.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.property.entity.User;

public interface UserService extends IService<User> {
    User login(String username, String password);
    boolean register(User user);
    boolean updatePassword(Long id, String oldPassword, String newPassword);
}