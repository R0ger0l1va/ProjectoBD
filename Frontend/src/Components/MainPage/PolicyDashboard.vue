<template>
  <div class="dashboard-container">
    <div class="dashboard-wrapper">
      <div class="dashboard-content">
        <h2 class="dashboard-title">Dashboard de Póliza de Seguro</h2>
        <div class="policy-info">
          <div v-for="(value, key) in policyData" :key="key" class="policy-item">
            <h3 class="policy-item-title">{{ formatLabel(key) }}</h3>
            <p class="policy-item-value">{{ formatValue(key, value) }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PolicyDashboard',
  data() {
    return {
      policyData: {
        companyName: "Seguros XYZ",
        clientName: "Juan Pérez",
        policyNumber: "POL-12345",
        startDate: new Date("2023-01-01"),
        endDate: new Date("2023-12-31"),
        coverageAmount: 100000,
        lastPay: 1000,
        Pay: 5000,
        State: "Activa"
        // Puedes agregar más campos aquí en el futuro
      }
    }
  },
  methods: {
    formatLabel(key) {
      const labels = {
        companyName: "Empresa Aseguradora",
        clientName: "Nombre del Cliente",
        policyNumber: "Número de Póliza",
        startDate: "Fecha de Inicio",
        endDate: "Fecha de Finalización",
        coverageAmount: "Monto de Cobertura",
        lastPay: "Ultima Prima Mensual",
        Pay: "Prima Mensual",
        State: "Estado de Poliza"
      }
      return labels[key] || key
    },
    formatValue(key, value) {
      if (value instanceof Date) {
        return value.toLocaleDateString()
      }
      if (key === 'coverageAmount') {
        return `$${value.toLocaleString()}`
      }
      return value
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  padding: 24px;
  background-color: #f3f4f6;
  min-height: 100vh;
}

.dashboard-wrapper {
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  background-color: #ffffff;
  
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
  border-radius: 40px;
  overflow: hidden;
}

.dashboard-content {
  padding: 24px;
}

.dashboard-title {
  font-size: 24px;
  font-weight: bold;
  text-align: center;
  margin-bottom: 24px;
  color: #333;
}

.policy-info {
  display: grid;
  gap: 16px;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
}

.policy-item {
  background-color: #f9fafb;
  border-radius: 40px;
  border-color: red;
  padding: 16px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  
}

.policy-item-title {
  font-size: 14px;
  font-weight: 600;
  color: #6b7280;
  margin-bottom: 8px;
}

.policy-item-value {
  font-size: 18px;
  font-weight: 500;
  color: #111827;
}

@media (max-width: 640px) {
  .policy-info {
    grid-template-columns: 1fr;
  }
}
</style>