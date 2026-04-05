package com.property.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("repair")
public class Repair implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long ownerId;
    private Long houseId;
    private String title;
    private String content;
    private String images;
    private Integer status;
    private String handler;
    private String handleContent;
    private Integer rating;
    private String comment;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}