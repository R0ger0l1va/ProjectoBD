<template>
  <div class="dashboard-container">
    <h1>Pólizas de {{ client.nombre_usuario }}</h1>
    
    <div v-if="policies.length > 0" class="policies-list">
      <div 
        v-for="policy in policies" 
        :key="policy.id" 
        class="policy-card" 
        :class="[
          getCoverageClass(policy.tipoCobertura),
          getStatusClass(policy.estadoPoliza)
        ]"
      >
        <h2>ID de Agencia: {{ policy.agenciaSeguro }}</h2>
        <div class="policy-details">
          <div class="detail-item">
            <span class="label">Número de Póliza:</span>
            <span class="value">{{ policy.numero_poliza }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Tipo de Seguro:</span>
            <span class="value">{{ policy.tipoSeguro }}</span>
          </div>
          <div v-if="isValidPolicy(policy.tipoSeguro)" class="detail-item">
            <span class="label">Estado Poliza:</span>
            <span class="value" :class="getStatusTextClass(policy.estadoPoliza)">{{ policy.estadoPoliza }}</span>
          </div>
          <div v-else class="detail-item invalid-policy">
            <span class="label">Estado Poliza:</span>
            <span class="value">No válida</span>
          </div>
          <div class="detail-item">
            <span class="label">Fecha de Inicio:</span>
            <span class="value">{{ formatDate(policy.fecha_inicio) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Fecha de Finalización:</span>
            <span class="value">{{ formatDate(policy.fecha_fin) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Tipo Cobertura:</span>
            <span class="value">{{ policy.tipoCobertura }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Pago Mensual:</span>
            <span class="value">{{ formatCurrency(policy.prima_mensual) }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Último Pago:</span>
            <span class="value">{{ policy.monto_total_asegurado }} </span>
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
        
          
      ],
      seguros:[]
        
      }
    },
 created() {
    const sessionData = sessionStorage.getItem('session');
    if (sessionData) {
      this.client = JSON.parse(sessionData);
      console.log(this.client);
      this.getPolizas()
    }
  },
  
  methods: {
    

     async getPolizas() {
      try {
        const res = await axios.get(`/getPolizas/${this.client.id_usuario}`);
        this.policies = res.data;
        await this.addDataPoliza();
        console.log(this.policies);
      } catch (error) {
        console.log(error);
      }
    },
    async addDataPoliza() {
      for (let policy of this.policies) {
        try {
          const res = await axios.get(`/getEstadoPoliza/${policy.id_estado_poliza}`);
          const segAge = await axios.get(`/getSegurosAgencia/${policy.id_agencia_seguro}`)
          const cob = await axios.get(`/getTipoCobertura/${policy.id_tipo_cobertura}`);
          const age = await axios.get(`/getAgencia/${policy.id_agencia_seguro}`);
          const seg = await axios.get(`/getTipoSeguro/${policy.id_tipo_seguro}`);
          this.seguros = segAge.data
          console.log(this.seguros);
          policy.agenciaSeguro = age.data.nombre_agencia_seguro
          policy.tipoCobertura = cob.data.nombre_tipo_cobertura
          policy.tipoSeguro = seg.data.nombre_tipo_seguro
          console.log(policy.tipoSeguro)
          policy.estadoPoliza = res.data.nombre_estado_poliza;
          console.log(policy.estadoPoliza);
        } catch (error) {
          console.log(error);
        }
      }
    },
    
    
   isValidPolicy(tipoSeguro) {
      return this.seguros.includes(tipoSeguro);
    },

    formatDate(dateString) {
      const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
    formatCurrency(amount) {
      return new Intl.NumberFormat('es-ES', { style: 'currency', currency: 'EUR' }).format(amount);
    },
    getCoverageClass(tipoCobertura) {
      switch (tipoCobertura.toLowerCase()) {
        case 'vip':
          return 'coverage-vip';
        case 'premium':
          return 'coverage-premium';
        case 'estandar':
          return 'coverage-estandar';
        default:
          return '';
      }
    },
    getStatusClass(estadoPoliza) {
      switch (estadoPoliza.toLowerCase()) {
        case 'activa':
          return 'status-active';
        case 'cancelada':
          return 'status-cancelled';
        case 'vencida':
          return 'status-expired';
        default:
          return '';
      }
    },
    getStatusTextClass(estadoPoliza) {
      switch (estadoPoliza.toLowerCase()) {
        case 'activa':
          return 'status-text-active';
        case 'cancelada':
          return 'status-text-cancelled';
        case 'vencida':
          return 'status-text-expired';
        default:
          return '';
      }
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

.policies-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.policy-card {
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.policy-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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

.no-policies {
  text-align: center;
  color: #666;
  font-style: italic;
  margin-top: 30px;
}

/* Coverage classes */
.coverage-vip {
  background-color: #ffd700;
}

.coverage-premium {
  background-color: #c0c0c0;
}

.coverage-estandar {
  background-color: #cd7f32;
}

/* Status classes */
.status-active {
  border: 2px solid #4caf50;
}

.status-cancelled {
  opacity: 0.8;
}

.status-expired {
  opacity: 0.9;
}

/* Status text classes */
.status-text-active {
  color: #4caf50;
  font-weight: bold;
}

.status-text-cancelled {
  color: #f44336;
  font-weight: bold;
}

.status-text-expired {
  color: #2196f3;
  font-weight: bold;
}

@media (max-width: 768px) {
  .policies-list {
    grid-template-columns: 1fr;
  }
}
</style>