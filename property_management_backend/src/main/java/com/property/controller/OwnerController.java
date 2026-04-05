package com.property.controller;

import com.property.entity.Owner;
import com.property.service.OwnerService;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/owner")
public class OwnerController {

    @Autowired
    private OwnerService ownerService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        List<Owner> list = ownerService.list();
        return Result.success().data("list", list).data("total", list.size());
    }

    @PostMapping("/add")
    public Result add(@RequestBody Owner owner) {
        boolean result = ownerService.save(owner);
        if (result) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping("/update")
    public Result update(@RequestBody Owner owner) {
        boolean result = ownerService.updateById(owner);
        if (result) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id) {
        boolean result = ownerService.removeById(id);
        if (result) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @GetMapping("/get/{id}")
    public Result get(@PathVariable Long id) {
        Owner owner = ownerService.getById(id);
        return Result.success().data("owner", owner);
    }
}