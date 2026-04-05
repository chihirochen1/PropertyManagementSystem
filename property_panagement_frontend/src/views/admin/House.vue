<template>
  <div class="house-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>房屋管理</span>
          <el-button type="primary" @click="openAddDialog">添加房屋</el-button>
        </div>
      </template>
      <el-table :data="houseList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="buildingId" label="楼栋ID" />
        <el-table-column prop="unit" label="单元" />
        <el-table-column prop="roomNumber" label="房间号" />
        <el-table-column prop="houseType" label="户型" />
        <el-table-column prop="area" label="面积" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'warning'">
              {{ scope.row.status === 1 ? '已入住' : '空闲' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button type="primary" size="small" @click="openEditDialog(scope.row)">编辑</el-button>
            <el-button type="danger" size="small" @click="deleteHouse(scope.row.id)">删除</el-button>
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

    <!-- 添加/编辑房屋对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="houseForm" :rules="houseRules" ref="houseFormRef" label-width="100px">
        <el-form-item label="楼栋ID" prop="buildingId">
          <el-input v-model="houseForm.buildingId" type="number" placeholder="请输入楼栋ID"></el-input>
        </el-form-item>
        <el-form-item label="单元" prop="unit">
          <el-input v-model="houseForm.unit" placeholder="请输入单元"></el-input>
        </el-form-item>
        <el-form-item label="房间号" prop="roomNumber">
          <el-input v-model="houseForm.roomNumber" placeholder="请输入房间号"></el-input>
        </el-form-item>
        <el-form-item label="户型" prop="houseType">
          <el-input v-model="houseForm.houseType" placeholder="请输入户型"></el-input>
        </el-form-item>
        <el-form-item label="面积" prop="area">
          <el-input v-model="houseForm.area" type="number" placeholder="请输入面积"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="houseForm.status" placeholder="请选择状态">
            <el-option label="空闲" value="0"></el-option>
            <el-option label="已入住" value="1"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="houseForm.description" type="textarea" placeholder="请输入描述"></el-input>
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

const houseList = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('添加房屋')
const houseFormRef = ref(null)

const houseForm = reactive({
  id: '',
  buildingId: '',
  unit: '',
  roomNumber: '',
  houseType: '',
  area: 0,
  status: 0,
  description: ''
})

const houseRules = {
  buildingId: [{ required: true, message: '请输入楼栋ID', trigger: 'blur' }],
  roomNumber: [{ required: true, message: '请输入房间号', trigger: 'blur' }]
}

onMounted(() => {
  getHouseList()
})

const getHouseList = async () => {
  try {
    const response = await axios.get('/house/list', {
      params: {
        page: currentPage.value,
        size: pageSize.value
      }
    });
    if (response.data.code === 200) {
      houseList.value = response.data.data.list;
      total.value = response.data.data.total;
    }
  } catch (error) {
    ElMessage.error('获取房屋列表失败');
  }
}

const handleSizeChange = (size) => {
  pageSize.value = size
  getHouseList()
}

const handleCurrentChange = (current) => {
  currentPage.value = current
  getHouseList()
}

const openAddDialog = () => {
  dialogTitle.value = '添加房屋'
  Object.assign(houseForm, {
    id: '',
    buildingId: '',
    unit: '',
    roomNumber: '',
    houseType: '',
    area: 0,
    status: 0,
    description: ''
  })
  dialogVisible.value = true
}

const openEditDialog = (row) => {
  dialogTitle.value = '编辑房屋'
  Object.assign(houseForm, row)
  dialogVisible.value = true
}

const submitForm = async () => {
  await houseFormRef.value.validate()
  try {
    let response
    if (houseForm.id) {
      response = await axios.put('/house/update', houseForm)
    } else {
      response = await axios.post('/house/add', houseForm)
    }
    if (response.data.code === 200) {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      getHouseList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteHouse = async (id) => {
  try {
    const response = await axios.delete(`/house/delete/${id}`)
    if (response.data.code === 200) {
      ElMessage.success('删除成功')
      getHouseList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('删除失败')
  }
}
</script>

<style scoped>
.house-management {
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