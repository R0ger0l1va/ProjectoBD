<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12">
        <h1 class="text-h4 text-center mb-6 primary--text">Pólizas de {{
            client.nombre_usuario
          }}</h1>
      </v-col>
    </v-row>

    <v-row v-if="policies.length > 0">
      <v-col v-for="policy in policies"
             :key="policy.id"
             cols="12"
             sm="6"
             md="4">
        <v-card
          :class="[
            getCoverageClass(policy.tipoCobertura),
            getStatusClass(policy.estadoPoliza) 
          ]"
          elevation="2"
          hover
        >
          <v-card-title> {{
              policy.agenciaSeguro
            }}
          </v-card-title>
          <v-card-text>
            <v-list
              dense>
              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Número de Póliza:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    policy.numero_poliza
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Tipo de Seguro:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    policy.tipoSeguro
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item v-if="isValidPolicy(policy.tipoSeguro)">
                <template v-slot:prepend>
                  <v-list-item-title>Estado Poliza:</v-list-item-title>
                </template>
                <v-list-item-subtitle :class="getStatusTextClass(policy.estadoPoliza)">
                  {{
                    policy.estadoPoliza
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item v-else>
                <template v-slot:prepend>
                  <v-list-item-title>Estado Poliza:</v-list-item-title>
                </template>
                <v-list-item-subtitle class="error--text">No válida</v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Fecha de Inicio:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    formatDate(policy.fecha_inicio)
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Fecha de Finalización:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    formatDate(policy.fecha_fin)
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Tipo Cobertura:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    policy.tipoCobertura
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Pago Mensual:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    formatCurrency(policy.prima_mensual)
                  }}
                </v-list-item-subtitle>
              </v-list-item>

              <v-list-item>
                <template v-slot:prepend>
                  <v-list-item-title>Último Pago:</v-list-item-title>
                </template>
                <v-list-item-subtitle>{{
                    policy.monto_total_asegurado
                  }}
                </v-list-item-subtitle>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row v-else
           justify="center">
      <v-col cols="12"
             sm="8"
             md="6">
        <v-alert type="info"
                 text>
          Este cliente no tiene pólizas activas en este momento.
        </v-alert>
      </v-col>
    </v-row>
  </v-container>
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
      policies: [],
      seguros: []
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
      const options = {year: 'numeric', month: '2-digit', day: '2-digit'};
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
    formatCurrency(amount) {
      return new Intl.NumberFormat('es-ES', {style: 'currency', currency: 'EUR'}).format(amount);
    },
    getCoverageClass(tipoCobertura) {
      switch (tipoCobertura) {
        case 'vip':
          return 'yellow lighten-3';
        case 'premium':
          return 'grey lighten-3';
        case 'estandar':
          return 'orange lighten-3';
        default:
          return '';
      }
    },
    getStatusClass(estadoPoliza) {
      switch (estadoPoliza) {
        case 'activa':
          return 'green--text text--darken-2';
        case 'cancelada':
          return 'red--text text--darken-2';
        case 'vencida':
          return 'blue--text text--darken-2';
        default:
          return '';
      }
    },
    getStatusTextClass(estadoPoliza) {
      switch (estadoPoliza) {
        case 'activa':
          return 'success--text';
        case 'cancelada':
          return 'error--text';
        case 'vencida':
          return 'info--text';
        default:
          return '';
      }
    }
  }
}
</script>

<style scoped>
.v-card {
  transition: all 0.3s ease;
}

.v-card:hover {
  transform: translateY(-5px);
}
</style>

