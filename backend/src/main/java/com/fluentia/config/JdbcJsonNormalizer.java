package com.fluentia.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.postgresql.util.PGobject;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * JDBC returns PostgreSQL {@code jsonb} as {@link PGobject}; Spring MVC would otherwise
 * JSON-serialize it as {@code {type, value, null}}. This converts those cells to real JSON values.
 */
@Component
public class JdbcJsonNormalizer {
    private final ObjectMapper objectMapper;

    public JdbcJsonNormalizer(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public void normalizeRows(List<Map<String, Object>> rows) {
        for (Map<String, Object> row : rows) {
            normalizeRow(row);
        }
    }

    public void normalizeRow(Map<String, Object> row) {
        for (Map.Entry<String, Object> e : row.entrySet()) {
            e.setValue(normalizeValue(e.getValue()));
        }
    }

    private Object normalizeValue(Object v) {
        if (v instanceof PGobject pg) {
            String pgType = pg.getType();
            if ("jsonb".equals(pgType) || "json".equals(pgType)) {
                String raw = pg.getValue();
                if (raw == null) {
                    return null;
                }
                try {
                    return objectMapper.readValue(raw, Object.class);
                } catch (JsonProcessingException ignored) {
                    return raw;
                }
            }
            return pg.getValue();
        }
        return v;
    }
}
