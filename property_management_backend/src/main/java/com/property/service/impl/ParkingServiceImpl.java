package com.property.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Parking;
import com.property.mapper.ParkingMapper;
import com.property.service.ParkingService;
import org.springframework.stereotype.Service;

@Service
public class ParkingServiceImpl extends ServiceImpl<ParkingMapper, Parking> implements ParkingService {
}