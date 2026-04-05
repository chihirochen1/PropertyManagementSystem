<template>
  <div class="owner-fee">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>我的缴费</span>
        </div>
      </template>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="待缴费" name="unpaid">
          <el-table :data="unpaidFees" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="feeType" label="费用类型" />
            <el-table-column prop="amount" label="金额" />
            <el-table-column prop="period" label="周期" />
            <el-table-column prop="createTime" label="创建时间" />
            <el-table-column label="操作" width="100">
              <template #default="scope">
                <el-button type="primary" size="small" @click="payFee(scope.row.id)">缴费</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="已缴费" name="paid">
          <el-table :data="paidFees" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="feeType" label="费用类型" />
            <el-table-column prop="amount" label="金额" />
            <el-table-column prop="period" label="周期" />
            <el-table-column prop="createTime" label="创建时间" />
            <el-table-column prop="payTime" label="缴费时间" />
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 缴费对话框 -->
    <el-dialog v-model="payDialogVisible" title="缴费">
      <div class="pay-info">
        <p>费用类型: {{ currentFee.feeType }}</p>
        <p>金额: ¥{{ currentFee.amount }}</p>
        <p>周期: {{ currentFee.period }}</p>
      </div>
      <div class="pay-method">
        <h4>选择支付方式</h4>
        <el-radio-group v-model="payMethod">
          <el-radio label="alipay">支付宝</el-radio>
          <el-radio label="wechat">微信支付</el-radio>
          <el-radio label="bank">银行卡</el-radio>
        </el-radio-group>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="payDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="confirmPay">确认缴费</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

const activeTab = ref('unpaid')
const payDialogVisible = ref(false)
const payMethod = ref('alipay')

const unpaidFees = ref([
  {
    id: 1,
    feeType: '物业费',
    amount: 200,
    period: '2024-01',
    createTime: '2024-01-01'
  },
  {
    id: 2,
    feeType: '水电费',
    amount: 150,
    period: '2024-01',
    createTime: '2024-01-01'
  }
])

const paidFees = ref([
  {
    id: 3,
    feeType: '物业费',
    amount: 200,
    period: '2023-12',
    createTime: '2023-12-01',
    payTime: '2023-12-15'
  }
])

const currentFee = reactive({
  feeType: '',
  amount: 0,
  period: ''
})

const payFee = (id) => {
  const fee = unpaidFees.value.find(f => f.id === id)
  if (fee) {
    Object.assign(currentFee, fee)
    payDialogVisible.value = true
  }
}

const confirmPay = () => {
  // 模拟缴费
  ElMessage.success('缴费成功')
  payDialogVisible.value = false
  // 实际项目中这里会调用API更新缴费状态
}
</script>

<style scoped>
.owner-fee {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pay-info {
  margin-bottom: 20px;
}

.pay-info p {
  margin-bottom: 10px;
}

.pay-method {
  margin-top: 20px;
}

.pay-method h4 {
  margin-bottom: 10px;
}
</style>