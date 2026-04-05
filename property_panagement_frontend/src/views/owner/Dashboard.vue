<template>
  <div class="owner-dashboard">
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card class="dashboard-card">
          <template #header>
            <div class="card-header">
              <span>最新公告</span>
            </div>
          </template>
          <div class="notice-list">
            <el-card v-for="notice in noticeList" :key="notice.id" class="notice-item">
              <h4>{{ notice.title }}</h4>
              <p>{{ notice.content }}</p>
              <span class="notice-time">{{ notice.createTime }}</span>
            </el-card>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="dashboard-card">
          <template #header>
            <div class="card-header">
              <span>待缴费提醒</span>
            </div>
          </template>
          <div class="fee-list">
            <el-card v-for="fee in feeList" :key="fee.id" class="fee-item">
              <div class="fee-info">
                <span class="fee-type">{{ fee.feeType }}</span>
                <span class="fee-amount">¥{{ fee.amount }}</span>
              </div>
              <span class="fee-period">{{ fee.period }}</span>
              <el-button type="primary" size="small" @click="payFee(fee.id)">立即缴费</el-button>
            </el-card>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="dashboard-card">
          <template #header>
            <div class="card-header">
              <span>个人房屋信息</span>
            </div>
          </template>
          <div class="house-info">
            <el-descriptions :column="1">
              <el-descriptions-item label="房屋ID">{{ houseInfo.id }}</el-descriptions-item>
              <el-descriptions-item label="楼栋">{{ houseInfo.buildingName }}</el-descriptions-item>
              <el-descriptions-item label="单元">{{ houseInfo.unit }}</el-descriptions-item>
              <el-descriptions-item label="房间号">{{ houseInfo.roomNumber }}</el-descriptions-item>
              <el-descriptions-item label="户型">{{ houseInfo.houseType }}</el-descriptions-item>
              <el-descriptions-item label="面积">{{ houseInfo.area }}㎡</el-descriptions-item>
            </el-descriptions>
          </div>
          <div class="quick-actions">
            <el-button type="primary" @click="goToRepair">
              <el-icon><Tools /></el-icon>
              快速报修
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { Tools } from '@element-plus/icons-vue'

const router = useRouter()
const noticeList = ref([
  {
    id: 1,
    title: '春节放假通知',
    content: '春节期间物业办公室放假安排：2月10日至2月17日放假，2月18日正常上班。',
    createTime: '2024-02-01'
  },
  {
    id: 2,
    title: '停水通知',
    content: '因管道维修，2月5日上午9:00至下午5:00将暂停供水，请各位业主提前做好储水准备。',
    createTime: '2024-02-03'
  }
])

const feeList = ref([
  {
    id: 1,
    feeType: '物业费',
    amount: 200,
    period: '2024-01'
  },
  {
    id: 2,
    feeType: '水电费',
    amount: 150,
    period: '2024-01'
  }
])

const houseInfo = ref({
  id: 1,
  buildingName: '1号楼',
  unit: '1单元',
  roomNumber: '101',
  houseType: '两室一厅',
  area: 80.5
})

onMounted(() => {
  // 实际项目中这里会调用API获取数据
})

const payFee = (id) => {
  // 模拟缴费
  ElMessage.success('缴费成功')
}

const goToRepair = () => {
  router.push('/owner/repair')
}
</script>

<style scoped>
.owner-dashboard {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.dashboard-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notice-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notice-item {
  margin-bottom: 10px;
}

.notice-time {
  font-size: 12px;
  color: #999;
}

.fee-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.fee-item {
  margin-bottom: 10px;
}

.fee-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.fee-type {
  font-weight: bold;
}

.fee-amount {
  color: #f56c6c;
  font-weight: bold;
}

.fee-period {
  font-size: 12px;
  color: #999;
  margin-bottom: 10px;
  display: block;
}

.house-info {
  margin-bottom: 20px;
}

.quick-actions {
  display: flex;
  justify-content: center;
}
</style>