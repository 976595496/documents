# spring Cloud Gateway 源码分析

老样子, 查看factories内配置如下

```properties
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
#  依赖包校验配置
org.springframework.cloud.gateway.config.GatewayClassPathWarningAutoConfiguration,\
#  Gateway核心配置
org.springframework.cloud.gateway.config.GatewayAutoConfiguration,\
# Gateway的Hystrix断路器配置
org.springframework.cloud.gateway.config.GatewayHystrixCircuitBreakerAutoConfiguration,\
# Gateway的Resilience4J断路器配置
org.springframework.cloud.gateway.config.GatewayResilience4JCircuitBreakerAutoConfiguration,\
#  gateway负载均衡客户端配置
org.springframework.cloud.gateway.config.GatewayLoadBalancerClientAutoConfiguration,\
#
org.springframework.cloud.gateway.config.GatewayNoLoadBalancerClientAutoConfiguration,\
#  路由度量配置
org.springframework.cloud.gateway.config.GatewayMetricsAutoConfiguration,\
#  流控的依赖配置信息
org.springframework.cloud.gateway.config.GatewayRedisAutoConfiguration,\
#  服务发现相关的依赖配置
org.springframework.cloud.gateway.discovery.GatewayDiscoveryClientAutoConfiguration,\
#  url全局处理映射配置
org.springframework.cloud.gateway.config.SimpleUrlHandlerMappingGlobalCorsAutoConfiguration,\
#
org.springframework.cloud.gateway.config.GatewayReactiveLoadBalancerClientAutoConfiguration

#网关环境后处理器
org.springframework.boot.env.EnvironmentPostProcessor=\
org.springframework.cloud.gateway.config.GatewayEnvironmentPostProcessor
```



### 依赖包校验配置

```java
@Configuration(proxyBeanMethods = false)
@AutoConfigureBefore(GatewayAutoConfiguration.class)
public class GatewayClassPathWarningAutoConfiguration {

	private static final Log log = LogFactory
			.getLog(GatewayClassPathWarningAutoConfiguration.class);

	private static final String BORDER = "\n\n**********************************************************\n\n";

	@Configuration(proxyBeanMethods = false)
	@ConditionalOnClass(name = "org.springframework.web.servlet.DispatcherServlet")
	protected static class SpringMvcFoundOnClasspathConfiguration {

		public SpringMvcFoundOnClasspathConfiguration() {
			log.warn(BORDER
					+ "Spring MVC found on classpath, which is incompatible with Spring Cloud Gateway at this time. "
					+ "Please remove spring-boot-starter-web dependency." + BORDER);
		}

	}

	@Configuration(proxyBeanMethods = false)
	@ConditionalOnMissingClass("org.springframework.web.reactive.DispatcherHandler")
	protected static class WebfluxMissingFromClasspathConfiguration {

		public WebfluxMissingFromClasspathConfiguration() {
			log.warn(BORDER + "Spring Webflux is missing from the classpath, "
					+ "which is required for Spring Cloud Gateway at this time. "
					+ "Please add spring-boot-starter-webflux dependency." + BORDER);
		}

	}

}
```

