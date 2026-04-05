package com.property.controller;

import com.property.entity.Parking;
import com.property.service.ParkingService;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/parking")
public class ParkingController {

    @Autowired
    private ParkingService parkingService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        List<Parking> list = parkingService.list();
        return Result.success().data("list", list).data("total", list.size());
    }

    @PostMapping("/add")
    public Result add(@RequestBody Parking parking) {
        boolean result = parkingService.save(parking);
        if (result) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping("/update")
    public Result update(@RequestBody Parking parking) {
        boolean result = parkingService.updateById(parking);
        if (result) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id) {
        boolean result = parkingService.removeById(id);
        if (result) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @GetMapping("/get/{id}")
    public Result get(@PathVariable Long id) {
        Parking parking = parkingService.getById(id);
        return Result.success().data("parking", parking);
    }
}