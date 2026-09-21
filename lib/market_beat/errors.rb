# Copyright (c) 2011-12 Michael Dvorkin
#
# Market Beat is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module MarketBeat
  # Base error class for all MarketBeat errors.
  class Error < StandardError; end

  # Raised when network requests fail (HTTP error, timeout, connection refused, DNS failure).
  class FetchError < Error; end

  # Raised when parsing API responses (XML, JSON, CSV) fails due to malformed data.
  class ParseError < Error; end
end
