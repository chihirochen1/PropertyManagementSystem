<template>
  <div class="repair-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>报修管理</span>
        </div>
      </template>
      <el-table :data="repairList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="ownerId" label="业主ID" />
        <el-table-column prop="houseId" label="房屋ID" />
        <el-table-column prop="title" label="报修标题" />
        <el-table-column prop="content" label="报修内容" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="handler" label="处理人" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleRepair(scope.row)">处理</el-button>
            <el-button type="info" size="small" @click="viewDetail(scope.row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 处理报修对话框 -->
    <el-dialog v-model="handleDialogVisible" title="处理报修">
      <el-form :model="repairForm" ref="repairFormRef" label-width="100px">
        <el-form-item label="报修标题">
          <el-input v-model="repairForm.title" disabled></el-input>
        </el-form-item>
        <el-form-item label="报修内容">
          <el-input v-model="repairForm.content" type="textarea" disabled></el-input>
        </el-form-item>
        <el-form-item label="处理人" prop="handler">
          <el-input v-model="repairForm.handler" placeholder="请输入处理人"></el-input>
        </el-form-item>
        <el-form-item label="处理内容" prop="handleContent">
          <el-input v-model="repairForm.handleContent" type="textarea" placeholder="请输入处理内容"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="repairForm.status" placeholder="请选择状态">
            <el-option label="待处理" value="0"></el-option>
            <el-option label="处理中" value="1"></el-option>
            <el-option label="已完成" value="2"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="handleDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitHandle">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const repairList = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const handleDialogVisible = ref(false)
const repairFormRef = ref(null)

const repairForm = reactive({
  id: '',
  title: '',
  content: '',
  handler: '',
  handleContent: '',
  status: 0
})

onMounted(() => {
  getRepairList()
})

const getRepairList = async () => {
  try {
    const response = await axios.get('/repair/list', {
      params: {
        page: currentPage.value,
        size: pageSize.value
      }
    });
    if (response.data.code === 200) {
      repairList.value = response.data.data.list;
      total.value = response.data.data.total;
    }
  } catch (error) {
    ElMessage.error('获取报修列表失败');
  }
}

const handleSizeChange = (size) => {
  pageSize.value = size
  getRepairList()
}

const handleCurrentChange = (current) => {
  currentPage.value = current
  getRepairList()
}

const getStatusType = (status) => {
  switch (status) {
    case 0: return 'warning'
    case 1: return 'info'
    case 2: return 'success'
    default: return ''
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 0: return '待处理'
    case 1: return '处理中'
    case 2: return '已完成'
    default: return ''
  }
}

const handleRepair = (row) => {
  Object.assign(repairForm, row)
  handleDialogVisible.value = true
}

const viewDetail = (row) => {
  Object.assign(repairForm, row)
  handleDialogVisible.value = true
}

const submitHandle = async () => {
  try {
    const response = await axios.put('/repair/update', repairForm)
    if (response.data.code === 200) {
      ElMessage.success('处理成功')
      handleDialogVisible.value = false
      getRepairList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('处理失败')
  }
}
</script>

<style scoped>
.repair-management {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>