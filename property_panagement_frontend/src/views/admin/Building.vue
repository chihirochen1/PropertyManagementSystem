<template>
  <div class="building-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>楼栋管理</span>
          <el-button type="primary" @click="openAddDialog">添加楼栋</el-button>
        </div>
      </template>
      <el-table :data="buildingList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="buildingName" label="楼栋名称" />
        <el-table-column prop="unitCount" label="单元数" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button type="primary" size="small" @click="openEditDialog(scope.row)">编辑</el-button>
            <el-button type="danger" size="small" @click="deleteBuilding(scope.row.id)">删除</el-button>
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

    <!-- 添加/编辑楼栋对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="buildingForm" :rules="buildingRules" ref="buildingFormRef" label-width="100px">
        <el-form-item label="楼栋名称" prop="buildingName">
          <el-input v-model="buildingForm.buildingName" placeholder="请输入楼栋名称"></el-input>
        </el-form-item>
        <el-form-item label="单元数" prop="unitCount">
          <el-input v-model="buildingForm.unitCount" type="number" placeholder="请输入单元数"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="buildingForm.status" placeholder="请选择状态">
            <el-option label="启用" value="1"></el-option>
            <el-option label="禁用" value="0"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="buildingForm.description" type="textarea" placeholder="请输入描述"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const buildingList = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('添加楼栋')
const buildingFormRef = ref(null)

const buildingForm = reactive({
  id: '',
  buildingName: '',
  unitCount: 0,
  status: 1,
  description: ''
})

const buildingRules = {
  buildingName: [{ required: true, message: '请输入楼栋名称', trigger: 'blur' }],
  unitCount: [{ required: true, message: '请输入单元数', trigger: 'blur' }]
}

onMounted(() => {
  getBuildingList()
})

const getBuildingList = async () => {
  try {
    const response = await axios.get('/building/list', {
      params: {
        page: currentPage.value,
        size: pageSize.value
      }
    });
    if (response.data.code === 200) {
      buildingList.value = response.data.data.list;
      total.value = response.data.data.total;
    }
  } catch (error) {
    ElMessage.error('获取楼栋列表失败');
  }
}

const handleSizeChange = (size) => {
  pageSize.value = size
  getBuildingList()
}

const handleCurrentChange = (current) => {
  currentPage.value = current
  getBuildingList()
}

const openAddDialog = () => {
  dialogTitle.value = '添加楼栋'
  Object.assign(buildingForm, {
    id: '',
    buildingName: '',
    unitCount: 0,
    status: 1,
    description: ''
  })
  dialogVisible.value = true
}

const openEditDialog = (row) => {
  dialogTitle.value = '编辑楼栋'
  Object.assign(buildingForm, row)
  dialogVisible.value = true
}

const submitForm = async () => {
  await buildingFormRef.value.validate()
  try {
    let response
    if (buildingForm.id) {
      response = await axios.put('/building/update', buildingForm)
    } else {
      response = await axios.post('/building/add', buildingForm)
    }
    if (response.data.code === 200) {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      getBuildingList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteBuilding = async (id) => {
  try {
    const response = await axios.delete(`/building/delete/${id}`)
    if (response.data.code === 200) {
      ElMessage.success('删除成功')
      getBuildingList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('删除失败')
  }
}
</script>

<style scoped>
.building-management {
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