def uuid = UUID.randomUUID().toString()
pipeline {
    agent { label 'nomadagent' }

    environment {
        NOMAD_JOB_STR = """


"""
    }
    stages {
        stage('Hello') {
            steps {
                writeFile file: 'job.nomad', text: """
job "automation-test-job-${env.BUILD_NUMBER}" {
    datacenters = ["dev"]
    namespace = "devops"
    type = "batch"
    reschedule {
        attempts       = 0
    }
    constraint {
        attribute = "\${attr.kernel.name}"
        value = "linux"
    }
    group "automation-test" {
        count = 1
        restart {
            attempts = 0
        }
        task "robot" {
            driver = "docker"
            template {
                data = <<EOH
                    DATABASE_CONFIG_DRIVER=ODBC Driver 18 for SQL Server
                EOH
                env = true
                destination = "local/runtime_env"
            }
            config {
                image = "docker.citigo.com.vn/elkcluster/retail-automation-test-v2"
                auth {
                    username = "autodeploy"
                    password = "FA6XNN8R2Yka"
                }
                volumes = [
                    "reports:/reports"
                ]
                entrypoint = ["pabot","--processes","8","-d","/reports","-i","smoke","TestSpecs"]
            }
            resources {
                cpu = 2000 # Mhz
                memory = 4128 # MB
                #memory_max = 15128 # MB
            }
        }
        task "autotest-integration" {
            driver = "docker"
            lifecycle {
                hook = "poststop"
                sidecar = false
            }
            template {
                data = <<EOH
                    AUTH_RETAIL_URL = "https://auth-retail.citigo.net"
                    OPS_RETAIL_URL = "https://ops-retail.citigo.net"
                    FILE_RETAIL_URL = "https://file-retail.citigo.net"
                    REPORT_PATH = "/reports"
                    RESULT_DIR = "/reports"
                    IS_UPLOAD_REPORT = "true"
                    RUN_UUID = "${uuid}"
                    IS_CREATE_TESTRESULT = "true"
                    IS_UPDATE_EXECUTION = "false"
                EOH
                env = true
                destination = "local/runtime_env"
            }
            config {
                image = "docker.citigo.com.vn/elkcluster/autotest-integration"
                auth {
                    username = "autodeploy"
                    password = "FA6XNN8R2Yka"
                }
                volumes = [
                    "..\${NOMAD_ALLOC_DIR}/../robot/reports/:/reports/"
                ]
                command = "result_to_opsretail"
            }
            resources {
                cpu = 300 # Mhz
                memory = 7428 # MB
                #memory_max = 16428 # MB
            }
        }
    }
}
                """
                sh """
                    /home/jenkins/.local/bin/nomadtools watch --purge run job.nomad
                """
            }
        }
    }
}
