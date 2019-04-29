class ApplicationJob < ActiveJob::Base

    def perform()
        feedstock = {}
        # manufactured = {1301 => {'time' => 50, 'qty' => }, 1201 => {'time' => 250, 'qty' =>},
        #             1209 => {'time' => 25.2, 'qty' =>}, 1109 => {'time' => 21.6, 'qty' =>},
        #             1309 => {'time' => 4.6, 'qty' =>}, 1106 => {'time' => 60, 'qty' =>},
        #             1114 => {'time' => 50, 'qty' =>}, 1215 => {'time' => 20, 'qty' =>},
        #             1115 => {'time' => 30, 'qty' =>}, 1105 => {'time' => 50, 'qty' =>},
        #             1013 => {'time' => 300, 'qty' =>}, 1216 => {'time' => 500, 'qty' =>},
        #             1116 => {'time' => 250, 'qty' =>}, 1110 => {'time' => 80, 'qty' =>},
        #             1310 => {'time' => 20, 'qty' =>}, 1210 => {'time' => 150, 'qty' =>},
        #             1112 => {'time' => 130, 'qty' =>}, 1108 => {'time' => 10, 'qty' =>},
        #             1407 => {'time' => 40, 'qty' =>}, 1207 => {'time' => 20, 'qty' =>},
        #             1107 => {'time' => 50, 'qty' =>}, 1307 => {'time' => 170, 'qty' =>},
        #             1211 => {'time' => 60, 'qty' =>}}

        manufactured = {1301 => {'stock_min' => 50, 'manufacture' => }, 1201 => {'stock_min' => 250, 'manufacture' =>},
                    1209 => {'stock_min' => 20, 'manufacture' =>}, 1109 => {'stock_min' => 50, 'manufacture' =>},
                    1309 => {'stock_min' => 170, 'manufacture' =>}, 1106 => {'stock_min' => 400, 'manufacture' =>},
                    1114 => {'stock_min' => 50, 'manufacture' =>}, 1215 => {'stock_min' => 20, 'manufacture' =>},
                    1115 => {'stock_min' => 30, 'manufacture' =>}, 1105 => {'stock_min' => 50, 'manufacture' =>},
                    1013 => {'stock_min' => 300, 'manufacture' =>}, 1216 => {'stock_min' => 500, 'manufacture' =>},
                    1116 => {'stock_min' => 250, 'manufacture' =>}, 1110 => {'stock_min' => 80, 'manufacture' =>},
                    1310 => {'stock_min' => 20, 'manufacture' =>}, 1210 => {'stock_min' => 150, 'manufacture' =>},
                    1112 => {'stock_min' => 130, 'manufacture' =>}, 1108 => {'stock_min' => 10, 'manufacture' =>},
                    1407 => {'stock_min' => 40, 'manufacture' =>}, 1207 => {'stock_min' => 20, 'manufacture' =>},
                    1107 => {'stock_min' => 50, 'manufacture' =>}, 1307 => {'stock_min' => 170, 'manufacture' =>},
                    1211 => {'stock_min' => 60, 'manufacture' =>}}







        self.class.set(:wait => 1.minutes).perform_later()
        puts("hola")

        # Revisar si hay ordenes de compra

        # Revisar stock disponible y pedir o fabricar en caso de ser necesario


    end
end
