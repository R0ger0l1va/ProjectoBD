<template>
  <div class="dashboard-container">
    <h1>Pólizas de {{ client.nombre_usuario }}</h1>
    
    <div v-if="policies.length > 0" class="policies-list">
      <div v-for="policy in policies" :key="policy.id" class="policy-card" :class="{ 'inactive': !policy.isActive }">
        <h2>{{ policy.companyName }}</h2>
        <div class="policy-details">
          <div class="detail-item">
            <span class="label">Número de Póliza:</span>
            <span class="value">{{ policy.policyNumber }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Fecha de Inicio:</span>
            <span class="value">{{ formatDate(policy.startDate) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Fecha de Finalización:</span>
            <span class="value">{{ formatDate(policy.endDate) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Estado:</span>
            <span class="value" :class="{ 'active': policy.isActive, 'inactive': !policy.isActive }">
              {{ policy.isActive ? 'Activa' : 'Inactiva' }}
            </span>
          </div>
          <div class="detail-item">
            <span class="label">Pago Mensual:</span>
            <span class="value">{{ formatCurrency(policy.monthlyPayment) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Último Pago:</span>
            <span class="value">{{ formatDate(policy.lastPaymentDate) }} - {{ formatCurrency(policy.lastPaymentAmount) }}</span>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="no-policies">
      <p>Este cliente no tiene pólizas activas en este momento.</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'ClientPolicyDashboard',
  data() {
    return {
      client: {
        id_usuario: '',
        nombre_usuario: '',
        contrasenna: '',
        rol: '',
      },
        policies: [
          {
            id: 1,
            companyName: 'Seguros XYZ',
            policyNumber: 'POL-12345',
            startDate: '2023-01-01',
            endDate: '2023-12-31',
            isActive: true,
            monthlyPayment: 100,
            lastPaymentDate: '2023-05-01',
            lastPaymentAmount: 100
          },
          {
            id: 2,
            companyName: 'Aseguradora ABC',
            policyNumber: 'POL-67890',
            startDate: '2023-02-15',
            endDate: '2024-02-14',
            isActive: false,
            monthlyPayment: 150,
            lastPaymentDate: '2023-04-15',
            lastPaymentAmount: 150
          },
          {
            id: 3,
            companyName: 'Seguros 123',
            policyNumber: 'POL-24680',
            startDate: '2023-03-01',
            endDate: '2024-02-29',
            isActive: true,
            monthlyPayment: 200,
            lastPaymentDate: '2023-05-01',
            lastPaymentAmount: 200
          }
        ]
      }
    },
 created() {
    const sessionData = sessionStorage.getItem('session');
    if (sessionData) {
      this.client = JSON.parse(sessionData);
      console.log(this.client);
    }
  },
  
  methods: {
    async getPolizas() {
      try {
        const res = axios.get('/getPolizas',this.client.id_usuario)
      } catch (error) {
        console.log(error);
        
      }
    },

    formatDate(dateString) {
      const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
    formatCurrency(amount) {
      return new Intl.NumberFormat('es-ES', { style: 'currency', currency: 'EUR' }).format(amount);
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h1 {
  color: #44917c;
  text-align: center;
  margin-bottom: 20px;
}

.client-info {
  background-color: #f0f0f0;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
}

.client-info p {
  margin: 5px 0;
}

.policies-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.policy-card {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.policy-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.policy-card.inactive {
  background-color: #e0e0e0;
  opacity: 0.8;
}

.policy-card h2 {
  color: #44917c;
  margin-top: 0;
  margin-bottom: 15px;
  font-size: 1.2em;
}

.policy-details {
  display: grid;
  gap: 10px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.label {
  font-weight: bold;
  color: #666;
}

.value {
  color: #333;
}

.value.active {
  color: #4caf50;
  font-weight: bold;
}

.value.inactive {
  color: #f44336;
  font-weight: bold;
}

.no-policies {
  text-align: center;
  color: #666;
  font-style: italic;
  margin-top: 30px;
}

@media (max-width: 768px) {
  .policies-list {
    grid-template-columns: 1fr;
  }
}
</style>