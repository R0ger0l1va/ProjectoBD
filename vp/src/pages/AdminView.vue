<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <h1 class="text-h3 mb-6">Dashboard de Seguros</h1>
      </v-col>
    </v-row>

    <!-- Pólizas Activas, Canceladas, Vencidas -->
    <v-row>
      <v-col v-for="(status, index) in policyStatuses"
             :key="index"
             cols="12"
             sm="4">
        <v-card :color="status.color"
                dark>
          <v-card-text>
            <div class="text-h5 mb-2">{{
                status.title
              }}
            </div>
            <v-progress-circular
              :rotate="-90"
              :size="100"
              :width="15"
              :model-value="status.value"
              color="white"
            >
              {{
                status.value
              }}
            </v-progress-circular>
            <div class="mt-2">Total: {{
                status.total
              }}
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Tipos de Siniestro -->
    <v-row class="mt-6">
      <v-col cols="12">
        <v-card>
          <v-card-title>Tipos de Siniestro</v-card-title>
          <v-card-text>
            <v-row>
              <v-col v-for="(siniestro, index) in tiposSiniestro"
                     :key="index"
                     cols="12"
                     sm="6"
                     md="4">
                <v-progress-linear
                  :model-value="siniestro.value"
                  :color="siniestro.color"
                  height="25"
                >
                  <template v-slot:default="{ value }">
                    <strong>{{
                        siniestro.type
                      }}: {{
                        Math.ceil(value)
                      }}%</strong>
                  </template>
                </v-progress-linear>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Tipos de Seguro -->
    <v-row class="mt-6">
      <v-col cols="12">
        <v-card>
          <v-card-title>Tipos de Seguro</v-card-title>
          <v-card-text>
            <v-row>
              <v-col v-for="(seguro, index) in tiposSeguro"
                     :key="index"
                     cols="12"
                     sm="6"
                     md="4">
                <v-chip :color="seguro.color"
                        label>
                  {{
                    seguro.type
                  }}: {{
                    seguro.count
                  }}
                </v-chip>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Prima Total Asegurada -->
    <v-row class="mt-6">
      <v-col cols="12">
        <v-card>
          <v-card-title>Prima Total Asegurada</v-card-title>
          <v-card-text>
            <div class="text-h4">{{
                formatCurrency(primaTotalAsegurada)
              }}
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Sección solo para trabajadores -->
    <v-row v-if="isTrabajador"
           class="mt-6">
      <v-col cols="12">
        <v-card color="info">
          <v-card-title class="white--text">Información para Trabajadores</v-card-title>
          <v-card-text>
            <div class="text-h5 white--text">
              Clientes con Pólizas Activas: {{
                clientesConPolizasActivas
              }}
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
  <router-view></router-view> <!-- Esto es crucial para mostrar los componentes hijos -->
</template>

<script>
export default {
  name: 'InsuranceDashboard',
  data() {
    return {
      isTrabajador: false, // Cambiar a true para ver la vista de trabajador
      policyStatuses: [
        {title: 'Pólizas Activas', value: 65, total: 150, color: 'success'},
        {title: 'Pólizas Canceladas', value: 20, total: 45, color: 'error'},
        {title: 'Pólizas Vencidas', value: 15, total: 35, color: 'warning'},
      ],
      tiposSiniestro: [
        {type: 'Enfermedad', value: 30, color: 'indigo'},
        {type: 'Desastre Natural', value: 15, color: 'deep-purple'},
        {type: 'Muerte', value: 10, color: 'red'},
        {type: 'Accidente Automovilístico', value: 25, color: 'blue'},
        {type: 'Accidente en Aeropuerto', value: 12, color: 'cyan'},
        {type: 'Otros', value: 8, color: 'teal'},
      ],
      tiposSeguro: [
        {type: 'Auto', count: 80, color: 'primary'},
        {type: 'Hogar', count: 60, color: 'secondary'},
        {type: 'Vida', count: 40, color: 'success'},
        {type: 'Salud', count: 70, color: 'info'},
        {type: 'Viaje', count: 30, color: 'warning'},
      ],
      primaTotalAsegurada: 5000000,
      clientesConPolizasActivas: 1200,
      polizas: [
        {id: 1, tipo: 'Auto', estado: 'Activa', prima: 1500},
        {id: 2, tipo: 'Hogar', estado: 'Activa', prima: 2000},
        {id: 3, tipo: 'Vida', estado: 'Cancelada', prima: 3000},
        {id: 4, tipo: 'Salud', estado: 'Vencida', prima: 1800},
        {id: 5, tipo: 'Viaje', estado: 'Activa', prima: 500},
      ],
    };
  },
  methods: {
    formatCurrency(value) {
      return new Intl.NumberFormat('es-ES', {style: 'currency', currency: 'EUR'}).format(value);
    },
  },
};
</script>

<style scoped>
.v-card {
  height: 100%;
}
</style>


