package com.property.controller;

import com.property.entity.Notice;
import com.property.service.NoticeService;
import com.property.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        List<Notice> list = noticeService.list();
        return Result.success().data("list", list).data("total", list.size());
    }

    @PostMapping("/add")
    public Result add(@RequestBody Notice notice) {
        boolean result = noticeService.save(notice);
        if (result) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping("/update")
    public Result update(@RequestBody Notice notice) {
        boolean result = noticeService.updateById(notice);
        if (result) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Long id) {
        boolean result = noticeService.removeById(id);
        if (result) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }

    @GetMapping("/get/{id}")
    public Result get(@PathVariable Long id) {
        Notice notice = noticeService.getById(id);
        return Result.success().data("notice", notice);
    }
}