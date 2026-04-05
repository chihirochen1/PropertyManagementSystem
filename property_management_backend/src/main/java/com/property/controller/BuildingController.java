package com.property.controller;

import com.property.entity.Building;
import com.property.service.BuildingService;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/building")
public class BuildingController {

    @Autowired
    private BuildingService buildingService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        List<Building> list = buildingService.list();
        return Result.success().data("list", list).data("total", list.size());
    }

    @PostMapping("/add")
    public Result add(@RequestBody Building building) {
        boolean result = buildingService.save(building);
        if (result) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping("/update")
    public Result update(@RequestBody Building building) {
        boolean result = buildingService.updateById(building);
        if (result) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id) {
        boolean result = buildingService.removeById(id);
        if (result) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @GetMapping("/get/{id}")
    public Result get(@PathVariable Long id) {
        Building building = buildingService.getById(id);
        return Result.success().data("building", building);
    }
}