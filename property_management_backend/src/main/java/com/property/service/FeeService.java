package com.property.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.property.entity.Fee;

public interface FeeService extends IService<Fee> {
    boolean payFee(Long id);
}