<template>
  <div class="owner-complaint">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>投诉建议</span>
          <el-button type="primary" @click="openAddDialog">提交投诉</el-button>
        </div>
      </template>
      <el-table :data="complaintList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="content" label="内容" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'warning'">
              {{ scope.row.status === 1 ? '已处理' : '待处理' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="replyContent" label="回复内容" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="操作" width="100">
          <template #default="scope">
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

    <!-- 提交投诉对话框 -->
    <el-dialog v-model="addDialogVisible" title="提交投诉">
      <el-form :model="complaintForm" :rules="complaintRules" ref="complaintFormRef" label-width="100px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="complaintForm.title" placeholder="请输入标题"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="complaintForm.content" type="textarea" placeholder="请输入内容"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitComplaint">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const complaintList = ref([
  {
    id: 1,
    title: '小区卫生问题',
    content: '小区垃圾清理不及时，希望物业加强管理。',
    status: 1,
    replyContent: '已安排增加清理频次，感谢您的反馈。',
    createTime: '2024-01-01'
  },
  {
    id: 2,
    title: '车辆乱停乱放',
    content: '小区内车辆乱停现象严重，影响通行。',
    status: 0,
    replyContent: '',
    createTime: '2024-01-02'
  }
])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(2)
const addDialogVisible = ref(false)
const complaintFormRef = ref(null)

const complaintForm = reactive({
  title: '',
  content: ''
})

const complaintRules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }]
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

const openAddDialog = () => {
  addDialogVisible.value = true
}

const submitComplaint = async () => {
  await complaintFormRef.value.validate()
  try {
    // 实际项目中这里会调用API提交投诉
    ElMessage.success('投诉提交成功')
    addDialogVisible.value = false
  } catch (error) {
    ElMessage.error('提交失败')
  }
}

const viewDetail = (row) => {
  // 查看详情
}
</script>

<style scoped>
.owner-complaint {
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