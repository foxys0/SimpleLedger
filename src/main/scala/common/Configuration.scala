package common

import java.io.{BufferedReader, FileNotFoundException, InputStreamReader}
import java.util.concurrent.TimeUnit

import akka.actor.typed.Extension
import akka.util.Timeout
import com.typesafe.config.{Config, ConfigFactory}
import common.Configuration.AppConfig

import scala.concurrent.duration.FiniteDuration
import scala.util.{Failure, Success, Try}

class Configuration(appConfig: AppConfig) extends Extension

object Configuration {

  case class DatabaseConfig(
    username: String,
    password: String,
    connectionString: String,
    driver: String,
    schema: String
  )

  case class AppConfig(databaseConfig: DatabaseConfig, timeout: Timeout)

  /**
    * Loads and parse configuration file
    *
    * @param path config file in jar
    * @return parsed configuration
    */
  def buildConfig(path: String): Config =
    Try(new BufferedReader(new InputStreamReader(getClass.getResourceAsStream(path)))) match {
      case Success(reader) => ConfigFactory.parseReader(reader).resolve()
      case Failure(_) => throw new FileNotFoundException(path)
    }

  /**
    * Parses typesafe config to [[AppConfig]]
    *
    * @param config typesafe config
    * @return parsed AppConfig
    */
  def buildAppConfig(config: Config): AppConfig = {
    val database = config.getConfig("simpleLedger.database")
    val duration = config.getDuration("simpleLedger.timeout")

    AppConfig(
      DatabaseConfig(
        database.getString("username"),
        database.getString("password"),
        database.getString("connectionString"),
        database.getString("driver"),
        database.getString("schema")
      ),
      FiniteDuration(duration.toNanos, TimeUnit.NANOSECONDS)
    )
  }

  /**
    * Loads configuration file and parses it to [[AppConfig]]
    *
    * @param path config file in jar
    * @return parsed AppConfig
    */
  def buildAppConfig(path: String): AppConfig = buildAppConfig(buildConfig(path))

}
