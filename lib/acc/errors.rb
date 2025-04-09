module ACC
  module Errors
    # Este módulo sirve como namespace para todas las clases de errores específicos

    # Clase base para todos los errores de ACC
    class Error < StandardError; end

    # Error de autenticación
    class AuthError < Error; end

    # Error de solicitud
    class RequestError < Error; end

    # Error de token de acceso
    class AccessTokenError < AuthError; end

    # Error de token de actualización
    class RefreshTokenError < AuthError; end

    # Error de alcance faltante
    class MissingScopeError < AuthError; end

    # Error de token de actualización faltante
    class MissingRefreshTokenError < AuthError; end
  end
end
