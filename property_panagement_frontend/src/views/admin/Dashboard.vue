<template>
  <div class="dashboard">
    <el-card class="dashboard-card">
      <template #header>
        <div class="card-header">
          <span>数据概览</span>
        </div>
      </template>
      <div class="stats-container">
        <el-statistic :value="ownerCount" title="住户总数" />
        <el-statistic :value="repairCount" title="待处理报修" />
        <el-statistic :value="monthlyFee" title="本月缴费" prefix="¥" />
        <el-statistic :value="arrearsCount" title="欠费统计" />
        <el-statistic :value="facilityRate" title="设施完好率" suffix="%" />
      </div>
    </el-card>

    <div class="charts-container">
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>报修趋势</span>
          </div>
        </template>
        <div ref="repairChart" class="chart"></div>
      </el-card>
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>费用统计</span>
          </div>
        </template>
        <div ref="feeChart" class="chart"></div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import * as echarts from 'echarts'

const ownerCount = ref(4)
const repairCount = ref(1)
const monthlyFee = ref(800)
const arrearsCount = ref(2)
const facilityRate = ref(75)

const repairChart = ref(null)
const feeChart = ref(null)

onMounted(() => {
  initRepairChart()
  initFeeChart()
})

const initRepairChart = () => {
  const chart = echarts.init(repairChart.value)
  const option = {
    xAxis: {
      type: 'category',
      data: ['1月', '2月', '3月', '4月', '5月', '6月']
    },
    yAxis: {
      type: 'value'
    },
    series: [{
      data: [12, 20, 15, 25, 18, 30],
      type: 'line'
    }]
  }
  chart.setOption(option)
}

const initFeeChart = () => {
  const chart = echarts.init(feeChart.value)
  const option = {
    xAxis: {
      type: 'category',
      data: ['物业费', '水电费', '停车费', '其他']
    },
    yAxis: {
      type: 'value'
    },
    series: [{
      data: [1200, 800, 500, 200],
      type: 'bar'
    }]
  }
  chart.setOption(option)
}
</script>

<style scoped>
.dashboard {
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

.stats-container {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
  margin-top: 20px;
}

.charts-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.chart-card {
  height: 300px;
}

.chart {
  width: 100%;
  height: 250px;
}
</style>