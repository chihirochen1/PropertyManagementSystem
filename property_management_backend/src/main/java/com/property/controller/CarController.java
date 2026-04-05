package com.property.controller;

import com.property.entity.Car;
import com.property.service.CarService;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/car")
public class CarController {

    @Autowired
    private CarService carService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        List<Car> list = carService.list();
        return Result.success().data("list", list).data("total", list.size());
    }

    @PostMapping("/add")
    public Result add(@RequestBody Car car) {
        boolean result = carService.save(car);
        if (result) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping("/update")
    public Result update(@RequestBody Car car) {
        boolean result = carService.updateById(car);
        if (result) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id) {
        boolean result = carService.removeById(id);
        if (result) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @GetMapping("/get/{id}")
    public Result get(@PathVariable Long id) {
        Car car = carService.getById(id);
        return Result.success().data("car", car);
    }
}