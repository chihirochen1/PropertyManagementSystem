<template>
  <div class="parking-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>停车管理</span>
        </div>
      </template>
      
      <el-tabs v-model="activeTab">
        <el-tab-pane label="车位管理" name="parking">
          <div class="mb-4">
            <el-button type="primary" size="small" @click="handleAddParking">
              <el-icon><Plus /></el-icon>
              新增车位
            </el-button>
          </div>
          
          <el-form :inline="true" :model="parkingSearchForm" class="mb-4">
            <el-form-item label="车位编号">
              <el-input v-model="parkingSearchForm.code" placeholder="请输入车位编号" style="width: 150px" />
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="parkingSearchForm.status" placeholder="请选择状态" style="width: 120px">
                <el-option label="空闲" value="1" />
                <el-option label="已占用" value="0" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleSearchParking">查询</el-button>
              <el-button @click="resetParkingForm">重置</el-button>
            </el-form-item>
          </el-form>
          
          <el-table :data="parkingList" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="code" label="车位编号" />
            <el-table-column prop="area" label="区域" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="scope">
                <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
                  {{ scope.row.status === 1 ? '空闲' : '已占用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="ownerName" label="业主姓名" width="120" />
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button size="small" @click="handleEditParking(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" @click="handleDeleteParking(scope.row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <div class="pagination-container">
            <el-pagination
              v-model:current-page="parkingPagination.currentPage"
              v-model:page-size="parkingPagination.pageSize"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="parkingPagination.total"
              @size-change="handleParkingSizeChange"
              @current-change="handleParkingCurrentChange"
            />
          </div>
        </el-tab-pane>
        
        <el-tab-pane label="车辆管理" name="car">
          <div class="mb-4">
            <el-button type="primary" size="small" @click="handleAddCar">
              <el-icon><Plus /></el-icon>
              新增车辆
            </el-button>
          </div>
          
          <el-form :inline="true" :model="carSearchForm" class="mb-4">
            <el-form-item label="车牌号">
              <el-input v-model="carSearchForm.licensePlate" placeholder="请输入车牌号" style="width: 150px" />
            </el-form-item>
            <el-form-item label="业主姓名">
              <el-input v-model="carSearchForm.ownerName" placeholder="请输入业主姓名" style="width: 150px" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleSearchCar">查询</el-button>
              <el-button @click="resetCarForm">重置</el-button>
            </el-form-item>
          </el-form>
          
          <el-table :data="carList" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="licensePlate" label="车牌号" />
            <el-table-column prop="ownerName" label="业主姓名" width="120" />
            <el-table-column prop="phone" label="联系电话" width="150" />
            <el-table-column prop="parkingCode" label="车位编号" width="120" />
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button size="small" @click="handleEditCar(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" @click="handleDeleteCar(scope.row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <div class="pagination-container">
            <el-pagination
              v-model:current-page="carPagination.currentPage"
              v-model:page-size="carPagination.pageSize"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="carPagination.total"
              @size-change="handleCarSizeChange"
              @current-change="handleCarCurrentChange"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    
    <!-- 车位新增/编辑对话框 -->
    <el-dialog
      v-model="parkingDialogVisible"
      :title="parkingDialogTitle"
      width="500px"
    >
      <el-form :model="parkingForm" :rules="parkingRules" ref="parkingFormRef">
        <el-form-item label="车位编号" prop="code">
          <el-input v-model="parkingForm.code" placeholder="请输入车位编号" />
        </el-form-item>
        <el-form-item label="区域" prop="area">
          <el-input v-model="parkingForm.area" placeholder="请输入区域" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="parkingForm.status" active-value="1" inactive-value="0" />
        </el-form-item>
        <el-form-item label="业主姓名" prop="ownerName">
          <el-input v-model="parkingForm.ownerName" placeholder="请输入业主姓名" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="parkingDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmitParking">确定</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 车辆新增/编辑对话框 -->
    <el-dialog
      v-model="carDialogVisible"
      :title="carDialogTitle"
      width="500px"
    >
      <el-form :model="carForm" :rules="carRules" ref="carFormRef">
        <el-form-item label="车牌号" prop="licensePlate">
          <el-input v-model="carForm.licensePlate" placeholder="请输入车牌号" />
        </el-form-item>
        <el-form-item label="业主姓名" prop="ownerName">
          <el-input v-model="carForm.ownerName" placeholder="请输入业主姓名" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="carForm.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="车位编号" prop="parkingCode">
          <el-input v-model="carForm.parkingCode" placeholder="请输入车位编号" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="carDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmitCar">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import { Plus } from '@element-plus/icons-vue';
import axios from 'axios';

export default {
  name: 'Parking',
  setup() {
    const activeTab = ref('parking');
    
    // 车位管理
    const parkingList = ref([]);
    const parkingDialogVisible = ref(false);
    const parkingDialogTitle = ref('新增车位');
    const parkingForm = reactive({
      id: '',
      code: '',
      area: '',
      status: 1,
      ownerName: ''
    });
    const parkingSearchForm = reactive({
      code: '',
      status: ''
    });
    const parkingPagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    });
    const parkingRules = {
      code: [{ required: true, message: '请输入车位编号', trigger: 'blur' }],
      area: [{ required: true, message: '请输入区域', trigger: 'blur' }]
    };
    const parkingFormRef = ref(null);
    
    // 车辆管理
    const carList = ref([]);
    const carDialogVisible = ref(false);
    const carDialogTitle = ref('新增车辆');
    const carForm = reactive({
      id: '',
      licensePlate: '',
      ownerName: '',
      phone: '',
      parkingCode: ''
    });
    const carSearchForm = reactive({
      licensePlate: '',
      ownerName: ''
    });
    const carPagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    });
    const carRules = {
      licensePlate: [{ required: true, message: '请输入车牌号', trigger: 'blur' }],
      ownerName: [{ required: true, message: '请输入业主姓名', trigger: 'blur' }],
      phone: [{ required: true, message: '请输入联系电话', trigger: 'blur' }]
    };
    const carFormRef = ref(null);
    
    // 获取车位列表
    const getParkingList = async () => {
      try {
        const response = await axios.get('/parking/list', {
          params: {
            page: parkingPagination.currentPage,
            size: parkingPagination.pageSize,
            ...parkingSearchForm
          }
        });
        if (response.data.code === 200) {
          parkingList.value = response.data.data.list;
          parkingPagination.total = response.data.data.total;
        }
      } catch (error) {
        console.error('获取车位列表失败:', error);
      }
    };
    
    // 获取车辆列表
    const getCarList = async () => {
      try {
        const response = await axios.get('/car/list', {
          params: {
            page: carPagination.currentPage,
            size: carPagination.pageSize,
            ...carSearchForm
          }
        });
        if (response.data.code === 200) {
          carList.value = response.data.data.list;
          carPagination.total = response.data.data.total;
        }
      } catch (error) {
        console.error('获取车辆列表失败:', error);
      }
    };
    
    // 新增车位
    const handleAddParking = () => {
      parkingDialogTitle.value = '新增车位';
      Object.assign(parkingForm, {
        id: '',
        code: '',
        area: '',
        status: 1,
        ownerName: ''
      });
      parkingDialogVisible.value = true;
    };
    
    // 编辑车位
    const handleEditParking = (row) => {
      parkingDialogTitle.value = '编辑车位';
      Object.assign(parkingForm, row);
      parkingDialogVisible.value = true;
    };
    
    // 删除车位
    const handleDeleteParking = async (id) => {
      try {
        const response = await axios.delete(`/parking/delete/${id}`);
        if (response.data.code === 200) {
          getParkingList();
        }
      } catch (error) {
        console.error('删除车位失败:', error);
      }
    };
    
    // 提交车位表单
    const handleSubmitParking = async () => {
      if (!parkingFormRef.value) return;
      await parkingFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            let response;
            if (parkingForm.id) {
              response = await axios.put('/parking/update', parkingForm);
            } else {
              response = await axios.post('/parking/add', parkingForm);
            }
            if (response.data.code === 200) {
              parkingDialogVisible.value = false;
              getParkingList();
            }
          } catch (error) {
            console.error('保存车位失败:', error);
          }
        }
      });
    };
    
    // 新增车辆
    const handleAddCar = () => {
      carDialogTitle.value = '新增车辆';
      Object.assign(carForm, {
        id: '',
        licensePlate: '',
        ownerName: '',
        phone: '',
        parkingCode: ''
      });
      carDialogVisible.value = true;
    };
    
    // 编辑车辆
    const handleEditCar = (row) => {
      carDialogTitle.value = '编辑车辆';
      Object.assign(carForm, row);
      carDialogVisible.value = true;
    };
    
    // 删除车辆
    const handleDeleteCar = async (id) => {
      try {
        const response = await axios.delete(`/car/delete/${id}`);
        if (response.data.code === 200) {
          getCarList();
        }
      } catch (error) {
        console.error('删除车辆失败:', error);
      }
    };
    
    // 提交车辆表单
    const handleSubmitCar = async () => {
      if (!carFormRef.value) return;
      await carFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            let response;
            if (carForm.id) {
              response = await axios.put('/car/update', carForm);
            } else {
              response = await axios.post('/car/add', carForm);
            }
            if (response.data.code === 200) {
              carDialogVisible.value = false;
              getCarList();
            }
          } catch (error) {
            console.error('保存车辆失败:', error);
          }
        }
      });
    };
    
    // 查询车位
    const handleSearchParking = () => {
      parkingPagination.currentPage = 1;
      getParkingList();
    };
    
    // 重置车位表单
    const resetParkingForm = () => {
      Object.assign(parkingSearchForm, {
        code: '',
        status: ''
      });
      parkingPagination.currentPage = 1;
      getParkingList();
    };
    
    // 分页车位
    const handleParkingSizeChange = (size) => {
      parkingPagination.pageSize = size;
      getParkingList();
    };
    
    const handleParkingCurrentChange = (current) => {
      parkingPagination.currentPage = current;
      getParkingList();
    };
    
    // 查询车辆
    const handleSearchCar = () => {
      carPagination.currentPage = 1;
      getCarList();
    };
    
    // 重置车辆表单
    const resetCarForm = () => {
      Object.assign(carSearchForm, {
        licensePlate: '',
        ownerName: ''
      });
      carPagination.currentPage = 1;
      getCarList();
    };
    
    // 分页车辆
    const handleCarSizeChange = (size) => {
      carPagination.pageSize = size;
      getCarList();
    };
    
    const handleCarCurrentChange = (current) => {
      carPagination.currentPage = current;
      getCarList();
    };
    
    onMounted(() => {
      getParkingList();
      getCarList();
    });
    
    return {
      activeTab,
      // 车位管理
      parkingList,
      parkingDialogVisible,
      parkingDialogTitle,
      parkingForm,
      parkingSearchForm,
      parkingPagination,
      parkingRules,
      parkingFormRef,
      handleAddParking,
      handleEditParking,
      handleDeleteParking,
      handleSubmitParking,
      handleSearchParking,
      resetParkingForm,
      handleParkingSizeChange,
      handleParkingCurrentChange,
      // 车辆管理
      carList,
      carDialogVisible,
      carDialogTitle,
      carForm,
      carSearchForm,
      carPagination,
      carRules,
      carFormRef,
      handleAddCar,
      handleEditCar,
      handleDeleteCar,
      handleSubmitCar,
      handleSearchCar,
      resetCarForm,
      handleCarSizeChange,
      handleCarCurrentChange,
      Plus
    };
  }
};
</script>

<style scoped>
.parking-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>