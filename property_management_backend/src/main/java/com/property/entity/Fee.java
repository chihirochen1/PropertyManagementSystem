package com.property.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("fee")
public class Fee implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long houseId;
    private Long ownerId;
    private String feeType;
    private Double amount;
    private String period;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime payTime;
}