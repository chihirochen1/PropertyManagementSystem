package com.property.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("complaint")
public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long ownerId;
    private String title;
    private String content;
    private Integer status;
    private String handler;
    private String replyContent;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}