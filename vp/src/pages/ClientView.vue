<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <v-card class="mb-4">
          <v-card-title class="text-h4">Entendiendo los Seguros</v-card-title>
          <v-card-text>
            <p class="text-body-1">
              Los seguros son una forma de protección financiera contra posibles riesgos futuros.
              Al contratar un seguro, usted transfiere el riesgo a una compañía aseguradora a cambio
              de pagos regulares llamados primas. Si ocurre un evento cubierto por su póliza, la
              aseguradora le proporcionará compensación financiera.
            </p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12"
             md="4"
             v-for="(info, index) in infoCards"
             :key="index">
        <v-card height="100%">
          <v-card-title class="text-h6">{{
              info.title
            }}
          </v-card-title>
          <v-card-text>
            <p>{{
                info.content
              }}</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row class="mt-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="text-h5">Historial de Pagos de su Póliza</v-card-title>
          <v-card-text>
            <v-sheet class="mx-auto"
                     height="150">
              <v-sparkline
                :value="sparklineData"
                :labels="sparklineLabels"
                :gradient="gradient"
                :smooth="10"
                type="trend"
                fill="false"
                :padding="8"
                :line-width="2"
                stroke-linecap="round"
                label-size="4"
                autoLineWidth:
                false
                gradient-direction="top"
                auto-draw
              ></v-sparkline>
            </v-sheet>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row class="mt-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="text-h5">Resumen de su Póliza</v-card-title>
          <v-card-text>
            <v-list>
              <v-list-item>
                <v-list-item-title>Tipo de Seguro:</v-list-item-title>
                <v-list-item-subtitle>{{
                    policyDetails.type
                  }}
                </v-list-item-subtitle>
              </v-list-item>
              <v-list-item>
                <v-list-item-title>Fecha de Compra:</v-list-item-title>
                <v-list-item-subtitle>{{
                    policyDetails.purchaseDate
                  }}
                </v-list-item-subtitle>
              </v-list-item>
              <v-list-item>
                <v-list-item-title>Último Pago:</v-list-item-title>
                <v-list-item-subtitle>{{
                    policyDetails.lastPayment
                  }}
                </v-list-item-subtitle>
              </v-list-item>
              <v-list-item>
                <v-list-item-title>Estado:</v-list-item-title>
                <v-list-item-subtitle>
                  <v-chip
                    :color="policyDetails.status === 'Activa' ? 'green' : 'red'"
                    text-color="white"
                  >
                    {{
                      policyDetails.status
                    }}
                  </v-chip>
                </v-list-item-subtitle>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row class="mt-4">
      <v-col cols="12">
        <v-card>
          <v-card-title class="text-h5">Beneficios de su Seguro</v-card-title>
          <v-card-text>
            <v-timeline align-top
                        dense>
              <v-timeline-item
                v-for="(benefit, index) in benefits"
                :key="index"
                :color="benefit.color"
                small
              >
                <div>
                  <div class="font-weight-normal">
                    <strong>{{
                        benefit.title
                      }}</strong>
                  </div>
                  <div>{{
                      benefit.description
                    }}
                  </div>
                </div>
              </v-timeline-item>
            </v-timeline>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
const gradients = [
  ['#222'],
  ['#42b3f4'],
  ['red', 'orange', 'yellow'],
  ['purple', 'violet'],
  ['#00c6ff', '#F0F', '#FF0'],
  ['#f72047', '#ffd200', '#1feaea'],
]
export default {
  name: 'ClienteDashboard',
  data() {
    return {
      gradient: gradients[5],
      infoCards: [
        {
          title: '¿Para qué sirven los seguros?',
          content: 'Los seguros proporcionan seguridad financiera, ayudan a manejar riesgos imprevistos y pueden ofrecer tranquilidad en situaciones difíciles.'
        },
        {
          title: '¿Por qué debería tener un seguro?',
          content: 'Un seguro le protege contra pérdidas financieras significativas, le ayuda a cumplir con obligaciones legales y puede proporcionar beneficios a largo plazo.'
        },
        {
          title: 'Tipos de seguros',
          content: 'Existen diversos tipos de seguros, incluyendo de vida, salud, automóvil, hogar y viaje. Cada uno está diseñado para cubrir riesgos específicos.'
        }
      ],
      sparklineData: [150, 230, 224, 218, 135, 147, 260],
      sparklineLabels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul'],
      policyDetails: {
        type: 'Seguro de Vida',
        purchaseDate: '01/01/2023',
        lastPayment: '01/07/2023',
        status: 'Activa'
      },
      benefits: [
        {
          title: 'Protección Financiera',
          description: 'Cobertura contra pérdidas económicas imprevistas.',
          color: 'green'
        },
        {
          title: 'Tranquilidad',
          description: 'Paz mental sabiendo que está protegido contra riesgos.',
          color: 'blue'
        },
        {
          title: 'Cumplimiento Legal',
          description: 'Ayuda a cumplir con requisitos legales en ciertos casos.',
          color: 'purple'
        },
        {
          title: 'Planificación a Largo Plazo',
          description: 'Facilita la planificación financiera y patrimonial.',
          color: 'orange'
        }
      ]
    };
  }
};
</script>

<style scoped>
.v-card {
  transition: all 0.3s ease;
}

.v-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.v-sparkline {
  height: 100%;
  width: 100%;
}
</style>

