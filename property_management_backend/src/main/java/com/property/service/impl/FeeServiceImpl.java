package com.property.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Fee;
import com.property.mapper.FeeMapper;
import com.property.service.FeeService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class FeeServiceImpl extends ServiceImpl<FeeMapper, Fee> implements FeeService {

    @Override
    public boolean payFee(Long id) {
        Fee fee = this.getById(id);
        if (fee != null) {
            fee.setStatus(1); // 已缴费
            fee.setPayTime(LocalDateTime.now());
            return this.updateById(fee);
        }
        return false;
    }
}