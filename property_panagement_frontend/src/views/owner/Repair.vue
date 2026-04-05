<template>
  <div class="owner-repair">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>我的报修</span>
          <el-button type="primary" @click="openAddDialog">提交报修</el-button>
        </div>
      </template>
      <el-table :data="repairList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
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
            <el-button type="info" size="small" @click="viewDetail(scope.row)">查看</el-button>
            <el-button v-if="scope.row.status === 2" type="primary" size="small" @click="evaluate(scope.row)">评价</el-button>
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

    <!-- 提交报修对话框 -->
    <el-dialog v-model="addDialogVisible" title="提交报修">
      <el-form :model="repairForm" :rules="repairRules" ref="repairFormRef" label-width="100px">
        <el-form-item label="报修标题" prop="title">
          <el-input v-model="repairForm.title" placeholder="请输入报修标题"></el-input>
        </el-form-item>
        <el-form-item label="报修内容" prop="content">
          <el-input v-model="repairForm.content" type="textarea" placeholder="请输入报修内容"></el-input>
        </el-form-item>
        <el-form-item label="房屋ID" prop="houseId">
          <el-input v-model="repairForm.houseId" type="number" placeholder="请输入房屋ID"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitRepair">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 评价对话框 -->
    <el-dialog v-model="evaluateDialogVisible" title="评价报修">
      <el-form :model="evaluateForm" :rules="evaluateRules" ref="evaluateFormRef" label-width="100px">
        <el-form-item label="评分" prop="rating">
          <el-rate v-model="evaluateForm.rating" :max="5" />
        </el-form-item>
        <el-form-item label="评价内容" prop="comment">
          <el-input v-model="evaluateForm.comment" type="textarea" placeholder="请输入评价内容"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="evaluateDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitEvaluate">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const repairList = ref([
  {
    id: 1,
    title: '水管漏水',
    content: '厨房水管漏水严重',
    status: 2,
    handler: '管理员',
    createTime: '2024-01-01'
  },
  {
    id: 2,
    title: '电路故障',
    content: '客厅电灯不亮',
    status: 1,
    handler: '管理员',
    createTime: '2024-01-02'
  }
])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(2)
const addDialogVisible = ref(false)
const evaluateDialogVisible = ref(false)
const repairFormRef = ref(null)
const evaluateFormRef = ref(null)

const repairForm = reactive({
  title: '',
  content: '',
  houseId: 1
})

const evaluateForm = reactive({
  id: '',
  rating: 5,
  comment: ''
})

const repairRules = {
  title: [{ required: true, message: '请输入报修标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入报修内容', trigger: 'blur' }],
  houseId: [{ required: true, message: '请输入房屋ID', trigger: 'blur' }]
}

const evaluateRules = {
  rating: [{ required: true, message: '请选择评分', trigger: 'blur' }],
  comment: [{ required: true, message: '请输入评价内容', trigger: 'blur' }]
}

onMounted(() => {
  // 实际项目中这里会调用API获取数据
})

const handleSizeChange = (size) => {
  pageSize.value = size
}

const handleCurrentChange = (current) => {
  currentPage.value = current
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

const openAddDialog = () => {
  addDialogVisible.value = true
}

const submitRepair = async () => {
  await repairFormRef.value.validate()
  try {
    // 实际项目中这里会调用API提交报修
    ElMessage.success('报修提交成功')
    addDialogVisible.value = false
  } catch (error) {
    ElMessage.error('提交失败')
  }
}

const viewDetail = (row) => {
  // 查看详情
}

const evaluate = (row) => {
  evaluateForm.id = row.id
  evaluateDialogVisible.value = true
}

const submitEvaluate = async () => {
  await evaluateFormRef.value.validate()
  try {
    // 实际项目中这里会调用API提交评价
    ElMessage.success('评价提交成功')
    evaluateDialogVisible.value = false
  } catch (error) {
    ElMessage.error('提交失败')
  }
}
</script>

<style scoped>
.owner-repair {
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